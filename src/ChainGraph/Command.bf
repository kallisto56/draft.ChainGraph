namespace System.Engine;


using System;
using System.Diagnostics;
using System.Math;


extension Chain
{
	public enum Command
	{
		case Undefined;

		case CopyTexture (ResourceAlias<Texture> source, ResourceAlias<Texture> destination, uint32 sx, uint32 sy, uint32 sw, uint32 sh, uint32 dx, uint32 dy, uint32 dw, uint32 dh);
		case UpdateBuffer (ResourceAlias<Buffer> buffer, uint32 offset, uint32 size, void* data);
		
		case Dispatch (uint32 groupCountX, uint32 groupCountY, uint32 groupCountZ);
		case DispatchIndirect (ResourceAlias<Buffer> indirectBuffer, uint32 offset);
		
		case DrawIndexed (uint32 indexCount, uint32 instanceCount, uint32 firstIndex, int32 vertexOffset, uint32 firstInstance);
		case DrawIndexedIndirect (ResourceAlias<Buffer> indirectBuffer, uint32 offset, uint32 drawCount, uint32 stride);
		case DrawIndirect (ResourceAlias<Buffer> indirectBuffer, uint32 offset, uint32 drawCount, uint32 stride);
		
		case ClearDepthStencilTarget (float depth, uint8 stencil);
		case ClearColorTarget (uint32 index, Color color);

		case BeginRenderPass (RenderPass renderPass);
		case EndRenderPass;
		
		case SetFramebuffer (ResourceAlias<Framebuffer> framebuffer);
		case SetIndexBuffer (ResourceAlias<Buffer> buffer, Buffer.IndexFormat format);
		case SetVertexBuffer (uint32 index, ResourceAlias<Buffer> buffer);
		case SetPipeline (Pipeline pipeline);
		case SetResourceSet (uint32 slot, ResourceSet set);
		case SetResourceSetCompute (uint32 slot, ResourceSet set);

		case SetScissors (uint32 index, int32 x, int32 y, int32 width, int32 height);
		case SetViewport (uint32 index, Viewport viewport);

		case WaitFor (IResourceAlias resourceAlias);
		case MakeAvailable (IResourceAlias resourceAlias);


		override public void ToString (String buffer)
		{
			switch (this)
			{
				case Undefined:
					buffer.Append("Undefined");
					break;

				case WaitFor(IResourceAlias resourceAlias):
					buffer.AppendF("WaitFor({})", resourceAlias);
					break;
				case MakeAvailable(IResourceAlias resourceAlias):
					buffer.AppendF("MakeAvaialble(\"{}::{}\")", resourceAlias.GetName(), resourceAlias.GetState());
					break;
				case CopyTexture(let source, let destination, let sx, let sy, let sw, let sh, let dx, let dy, let dw, let dh):
					buffer.AppendF("CopyTexture({}, {}, {}, {}, {}, {}, {}, {}, {}, {})", source, destination, sx, sy, sw, sh, dx, dy, dw, dh);
					break;
				case UpdateBuffer:
					buffer.Append("UpdateBuffer");
					break;

				case Dispatch:
					buffer.Append("Dispatch");
					break;
				case DispatchIndirect:
					buffer.Append("DispatchIndirect");
					break;

				case DrawIndexed(let indexCount, let instanceCount, let firstIndex, let vertexOffset, let firstInstance):
					buffer.AppendF("DrawIndexed({}, {}, {}, {}, {})", indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);
					break;
				case DrawIndexedIndirect:
					buffer.Append("DrawIndexedIndirect");
					break;
				case DrawIndirect:
					buffer.Append("DrawIndirect");
					break;

				case SetScissors:
					buffer.Append("SetScissors");
					break;
				case SetViewport:
					buffer.Append("SetViewport");
					break;
				case ClearDepthStencilTarget:
					buffer.Append("ClearDepthStencilTarget");
					break;
				case ClearColorTarget(let index, let color):
					buffer.AppendF("ClearColorTarget({}, {})", index, color);
					break;
				case SetFramebuffer(let resourceAlias):
					buffer.AppendF("SetFramebuffer(\"{}::{}\")", resourceAlias.GetName(), resourceAlias.GetState());
					break;
				case BeginRenderPass(let renderPass):
					buffer.AppendF("BeginRenderPass(\"{}\")", renderPass.GetName());
					break;
				case EndRenderPass:
					buffer.Append("EndRenderPass");
					break;

				case SetIndexBuffer:
					buffer.Append("SetIndexBuffer");
					break;
				case SetVertexBuffer:
					buffer.Append("SetVertexBuffer");
					break;
				case SetPipeline(Pipeline pipeline):
					buffer.AppendF("SetPipeline(pipeline: {})", pipeline);
					break;
				case SetResourceSet(let slot, let set):
					buffer.AppendF("SetResourceSet(slot: {}, set: {})", slot, set);
					break;
				case SetResourceSetCompute:
					buffer.Append("SetResourceSetCompute");
					break;
			}
		}
	}
}