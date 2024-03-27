namespace System.Engine;


using System;
using System.Collections;
using System.Diagnostics;


extension ChainGraph
{
	public class Node
	{
		public String mName;
		public Node mParent;
		public List<Node> mChildren;

		public Chain.Command mCommand;

		public List<IResourceAlias> mResourcesToWaitFor;
		public List<IResourceAlias> mResourceToMakeAvailable;


		public this (Node parent, Chain.Command command)
		{
			this.mName = new String();
			this.mCommand = command;
			this.mParent = parent;
			this.mChildren = new List<Node>();
			this.mResourcesToWaitFor = new List<IResourceAlias>();
			this.mResourceToMakeAvailable = new List<IResourceAlias>();
		}


		public ~this ()
		{
			DeleteAndNullify!(this.mName);
			DeleteContainerAndItems!(this.mChildren);
			DeleteAndNullify!(this.mResourcesToWaitFor);
			DeleteAndNullify!(this.mResourceToMakeAvailable);
		}


		override public void ToString (String buffer)
		{
			buffer.AppendF("{}", this.mCommand);
		}
	}
}