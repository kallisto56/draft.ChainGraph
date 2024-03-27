namespace test.ChainedRenderGraph;


using System;
using System.Collections;
using System.Diagnostics;
using System.Engine;
using System.Math;


typealias FramebufferAlias = ResourceAlias<Framebuffer>;
typealias RenderPassAlias = ResourceAlias<RenderPass>;
typealias BufferAlias = ResourceAlias<Buffer>;


class Program
{
	static void Main ()
	{
		ChainGraph chainGraph = scope ChainGraph();

		// Resources
		var framebuffer = scope Framebuffer("MainFramebuffer");
		var clearingPass = scope RenderPass("ClearingPass");
		var opaquePass = scope RenderPass("OpaquePass");
		var transparentPass = scope RenderPass("TransparentPass");
		var uiPass = scope RenderPass("UIPass");

		var bufferMatrices = scope Buffer("BufferForMatrices");

		var computePipeline = scope Pipeline("ComputePipeline");
		var opaquePipeline = scope Pipeline("OpaquePipeline");
		var transparentPipeline = scope Pipeline("TransparentPipeline");
		var uiPipeline = scope Pipeline("UIPipeline");

		var primaryOpaqueResourceSet = scope ResourceSet("primaryOpaqueResourceSet");
		var secondaryOpaqueResourceSet = scope ResourceSet("secondaryOpaqueResourceSet");
		var tertiaryOpaqueResourceSet = scope ResourceSet("tertiaryOpaqueResourceSet");

		// Aliases
		var acquiredFramebuffer = scope FramebufferAlias("Acquired", framebuffer);
		var cleanedFramebuffer = scope FramebufferAlias("Cleaned", framebuffer);
		var uiFramebuffer = scope FramebufferAlias("UIStage", framebuffer);
		var updatedBufferForMatrices = scope BufferAlias("PreparedBufferForMatrices", bufferMatrices);


		chainGraph.Add(
			scope Chain("Framebuffer.Clean()")
			..SetFramebuffer(acquiredFramebuffer)
			..ClearColorTarget(0, .black)
			..BeginRenderPass(clearingPass)
			..EndRenderPass()
			..MakeAvailable(cleanedFramebuffer)
		);

		chainGraph.Add(
			scope Chain("TransitionToUIStage")
			..WaitFor(cleanedFramebuffer)
			..MakeAvailable(uiFramebuffer)
		);

		for (uint32 n = 0; n < 3; n++)
		{
			chainGraph.Add(
				scope Chain("UIGeometry")
				..SetFramebuffer(uiFramebuffer)
				..BeginRenderPass(uiPass)
				..SetPipeline(uiPipeline)
				..SetResourceSet(0, primaryOpaqueResourceSet)
				..SetResourceSet(1, tertiaryOpaqueResourceSet)
				..DrawIndexed((n*10)+60, (n*10)+61, (n*10)+62, (.)(n*10)+63, (n*10)+64)
				..EndRenderPass()
			);
		}

		chainGraph.Add(
			scope Chain("RandomOpaqueObject")
				..SetFramebuffer(cleanedFramebuffer)
				..BeginRenderPass(opaquePass)
				..SetPipeline(opaquePipeline)
				..DrawIndexed(10, 11, 12, 13, 14)
				..EndRenderPass()
		);

		chainGraph.Add(
			scope Chain("StandardOpaqueGeometry#1")
			..WaitFor(updatedBufferForMatrices)
			..SetFramebuffer(cleanedFramebuffer)
			..BeginRenderPass(opaquePass)
			..SetPipeline(opaquePipeline)
			..SetResourceSet(0, primaryOpaqueResourceSet)
			..SetResourceSet(1, secondaryOpaqueResourceSet)
			..DrawIndexed(20, 21, 22, 23, 24)
			..EndRenderPass()
		);

		chainGraph.Add(
			scope Chain("StandardOpaqueGeometry#2")
			..WaitFor(updatedBufferForMatrices)
			..SetFramebuffer(cleanedFramebuffer)
			..BeginRenderPass(opaquePass)
			..SetPipeline(opaquePipeline)
			..SetResourceSet(0, primaryOpaqueResourceSet)
			..SetResourceSet(1, secondaryOpaqueResourceSet)
			..DrawIndexed(30, 31, 32, 33, 34)
			..EndRenderPass()
		);

		chainGraph.Add(
			scope Chain("StandardTransparentGeometry")
			..WaitFor(updatedBufferForMatrices)
			..SetFramebuffer(cleanedFramebuffer)
			..BeginRenderPass(transparentPass)
			..SetPipeline(transparentPipeline)
			..SetResourceSet(0, primaryOpaqueResourceSet)
			..SetResourceSet(1, secondaryOpaqueResourceSet)
			..DrawIndexed(40, 41, 42, 43, 44)
			..EndRenderPass()
		);

		chainGraph.Add(
			scope Chain("StandardTransparentGeometry")
			..WaitFor(updatedBufferForMatrices)
			..SetFramebuffer(cleanedFramebuffer)
			..BeginRenderPass(transparentPass)
			..SetPipeline(transparentPipeline)
			..SetResourceSet(0, primaryOpaqueResourceSet)
			..SetResourceSet(1, tertiaryOpaqueResourceSet)
			..DrawIndexed(50, 51, 52, 53, 54)
			..EndRenderPass()
		);

		chainGraph.Add(
			scope Chain("ComputeMatrices")
			..SetPipeline(computePipeline)
			..SetResourceSet(0, primaryOpaqueResourceSet)
			..SetResourceSet(1, tertiaryOpaqueResourceSet)
			..Dispatch(56, 56, 56)
			..MakeAvailable(updatedBufferForMatrices)
		);

		chainGraph.Add(
			scope Chain("Initially available resources")
			..MakeAvailable(acquiredFramebuffer)
		);

		chainGraph.Compute();

		Debug.WriteLine("Result of sorting:");
		var rootNode = scope ChainGraph.Node(null, .Undefined);
		rootNode.mChildren.AddRange(chainGraph.mOrderedNodes);

		var string = DumpNode(.. scope String(), rootNode);
		Debug.WriteLine(string);
		rootNode.mChildren.Clear();
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