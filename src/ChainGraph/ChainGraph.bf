namespace System.Engine;


using System;
using System.Collections;
using System.Diagnostics;


class ChainGraph
{
	public Node mRootNode;
	public List<Chain.Command> mOrderedCommands;
	public List<Node> mOrderedNodes;


	public this ()
	{
		this.mRootNode = new Node(null, .Undefined);
		this.mOrderedCommands = new List<Chain.Command>();
		this.mOrderedNodes = new List<Node>();
	}


	public ~this ()
	{
		DeleteAndNullify!(this.mRootNode);
		DeleteAndNullify!(this.mOrderedCommands);
		DeleteAndNullify!(this.mOrderedNodes);
	}


	public void Add (Chain chain)
	{
		Node parent = this.mRootNode;
		Node previousParent = this.mRootNode;

		for (var command in chain.mCommands)
		{
			// EndRenderPass will be added when we encounter BeginRenderPass 
			// Chain of commands after BeginRenderPass can be very deep.
			if (command case .EndRenderPass)
				continue;

			// Search for identical node in the graph
			bool bIdenticalNodeFound = this.TryGet(parent, command, var identicalNode);

			// Case 1: identical node has been found, we can merge
			// Case 2: no identical node found, we can create new one
			if (bIdenticalNodeFound == true)
			{
				parent = identicalNode;
			}
            else
			{
				parent = parent.mChildren.Add(.. new Node(parent, command));
				parent.mName.Set(chain.mName);
			}

			// Add 'EndRenderPass' to the parent unless it already exists
			if (command case .BeginRenderPass && this.TryGet(previousParent, .EndRenderPass, var _) == false)
				previousParent.mChildren.Add(.. new Node(previousParent, .EndRenderPass));

			// ...
			previousParent = parent;
		}
	}


	bool TryGet (Node node, Chain.Command command, out Node identical)
	{
		identical = default;

		for (var child in node.mChildren)
		{
			if (child.mCommand == command)
			{
				identical = child;
				return true;
			}
		}

		return false;
	}


	public void Compute ()
	{
		// Construct state, that will act as a container for temporary data
		State e = scope State();
		e.mAwaitingNodes.AddRange(this.mRootNode.mChildren);

		// Accumulate dependencies (resources that each node waits for and makes available)
		for (var node in e.mAwaitingNodes)
			this.AccumulateDependencies(node, node.mResourcesToWaitFor, node.mResourceToMakeAvailable);

		while (e.mAwaitingNodes.Count > 0)
		{
			let countAwaitingNodes = e.mAwaitingNodes.Count;

			for (var node in e.mAwaitingNodes)
			{
				if (e.AllResourcesAvailableFor(node) == false)
					continue;

				if (e.NodeCanSwitchState(node) == false)
					continue;

				e.SwitchState(node);
				this.mOrderedNodes.Add(node);
				@node.Remove();
			}

			if (countAwaitingNodes == e.mAwaitingNodes.Count)
			{
				Debug.WriteLine("ERROR: Cyclic dependency or absence of resource alises that awaiting nodes rely on.");
				break;
			}
		}
	}


	void AccumulateDependencies (Node node, List<IResourceAlias> mResourcesToWaitFor, List<IResourceAlias> mResourceToMakeAvailable)
	{
		if (node.mCommand case .WaitFor(let resourceAlias))
		{
			mResourcesToWaitFor.Add(resourceAlias);
		}
		else if (node.mCommand case .MakeAvailable(let resourceAlias))
		{
			mResourceToMakeAvailable.Add(resourceAlias);
		}

		for (var child in node.mChildren)
			AccumulateDependencies(child, mResourcesToWaitFor, mResourceToMakeAvailable);
	}


	class State
	{
		public Dictionary<StringView, StringView> mAvailableResources;
		public List<Node> mAwaitingNodes;


		public this ()
		{
			this.mAvailableResources = new Dictionary<StringView, StringView>();
			this.mAwaitingNodes = new List<ChainGraph.Node>();
		}


		public ~this ()
		{
			DeleteAndNullify!(this.mAvailableResources);
			DeleteAndNullify!(this.mAwaitingNodes);
		}


		public bool AllResourcesAvailableFor (Node node)
		{
			for (var resourceAlias in node.mResourcesToWaitFor)
				if (this.ContainsResourceAlias(resourceAlias) == false)
					return false;

			return true;
		}


		public bool ContainsResourceAlias (IResourceAlias resourceAlias)
		{
			if (this.mAvailableResources.TryGet(resourceAlias.GetName(), var matchKey, var state) == false)
				return false;

			return resourceAlias.GetState() == state;
		}


		public bool NodeCanSwitchState (Node node)
		{
			if (node.mResourceToMakeAvailable.Count == 0)
				return true;

			for (var resourceAlias in node.mResourceToMakeAvailable)
			{
				if (this.mAvailableResources.TryGet(resourceAlias.GetName(), var resourceName, var resourceState) == false)
					continue;

				if (this.AnyAwaitingNodesThatUse(node, resourceName, resourceState) == true)
					return false;
			}

			return true;
		}


		public bool AnyAwaitingNodesThatUse (Node exclude, StringView name, StringView state)
		{
			for (var node in this.mAwaitingNodes)
			{
				if (exclude == node)
					continue;

				for (var dependency in node.mResourcesToWaitFor)
					if (dependency.GetName() == name && dependency.GetState() == state)
						return true;
			}

			return false;
		}


		public void SwitchState (Node node)
		{
			if (node.mResourceToMakeAvailable.Count == 0)
				return;

			for (var resourceAlias in node.mResourceToMakeAvailable)
			{
				if (this.mAvailableResources.TryAdd(resourceAlias.GetName(), resourceAlias.GetState()) == false)
					this.mAvailableResources[resourceAlias.GetName()] = resourceAlias.GetState();
			}
		}
	}


	static void DumpNode (String buffer, ChainGraph.Node node, int level = 0)
	{
		String indentation = scope String();
		for (int n = 0; n < level; n++)
			indentation.Append("	");

		buffer.AppendF("{}{}\n", indentation, node);

		for (var child in node.mChildren)
			DumpNode(buffer, child, level + 1);
	}
}