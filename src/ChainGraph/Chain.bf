namespace System.Engine;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


class Chain
{
	public StringView mName;
	public List<Command> mCommands;


	public this (StringView name)
	{
		this.mName = name;
		this.mCommands = new List<Command>();
	}


	public ~this ()
	{
		DeleteAndNullify!(this.mCommands);
	}


	public void CopyTexture (ResourceAlias<Texture> source, ResourceAlias<Texture> destination, uint32 sx, uint32 sy, uint32 sw, uint32 sh, uint32 dx, uint32 dy, uint32 dw, uint32 dh)
	{
		this.WaitFor(source);
		this.MakeAvailable(destination);
		this.mCommands.Add(.CopyTexture(source, destination, sx, sy, sw, sh, dx, dy, dw, dh));
	}

	public void UpdateBuffer (ResourceAlias<Buffer> buffer, uint32 offset, uint32 size, void* data)
	{
		this.WaitFor(buffer);
		this.mCommands.Add(.UpdateBuffer(buffer, offset, size, data));
	}

	public void Dispatch (uint32 groupCountX, uint32 groupCountY, uint32 groupCountZ)
	{
		this.mCommands.Add(.Dispatch(groupCountX, groupCountY, groupCountZ));
	}

	public void DispatchIndirect (ResourceAlias<Buffer> indirectBuffer, uint32 offset)
	{
		this.WaitFor(indirectBuffer);
		this.mCommands.Add(.DispatchIndirect(indirectBuffer, offset));
	}

	public void DrawIndexed (uint32 indexCount, uint32 instanceCount, uint32 firstIndex, int32 vertexOffset, uint32 firstInstance)
	{
		this.mCommands.Add(.DrawIndexed(indexCount, instanceCount, firstIndex, vertexOffset, firstInstance));
	}

	public void DrawIndexedIndirect (ResourceAlias<Buffer> indirectBuffer, uint32 offset, uint32 drawCount, uint32 stride)
	{
		this.WaitFor(indirectBuffer);
		this.mCommands.Add(.DrawIndexedIndirect(indirectBuffer, offset, drawCount, stride));
	}

	public void DrawIndirect (ResourceAlias<Buffer> indirectBuffer, uint32 offset, uint32 drawCount, uint32 stride)
	{
		this.WaitFor(indirectBuffer);
		this.mCommands.Add(.DrawIndirect(indirectBuffer, offset, drawCount, stride));
	}

	public void SetScissors (uint32 index, int32 x, int32 y, int32 width, int32 height)
	{
		this.mCommands.Add(.SetScissors(index, x, y, width, height));
	}

	public void SetViewport (uint32 index, Viewport viewport)
	{
		this.mCommands.Add(.SetViewport(index, viewport));
	}

	public void ClearDepthStencilTarget (float depth, uint8 stencil)
	{
		this.mCommands.Add(.ClearDepthStencilTarget(depth, stencil));
	}

	public void ClearColorTarget (uint32 index, Color color)
	{
		this.mCommands.Add(.ClearColorTarget(index, color));
	}

	public void SetFramebuffer (ResourceAlias<Framebuffer> framebuffer)
	{
		this.WaitFor(framebuffer);
		this.mCommands.Add(.SetFramebuffer(framebuffer));
	}

	public void BeginRenderPass (RenderPass renderPass)
	{
		this.mCommands.Add(.BeginRenderPass(renderPass));
	}

	public void EndRenderPass ()
	{
		this.mCommands.Add(.EndRenderPass);
	}

	public void SetIndexBuffer (ResourceAlias<Buffer> buffer, Buffer.IndexFormat format)
	{
		this.WaitFor(buffer);
		this.mCommands.Add(.SetIndexBuffer(buffer, format));
	}

	public void SetVertexBuffer (uint32 index, ResourceAlias<Buffer> buffer)
	{
		this.mCommands.Add(.SetVertexBuffer(index, buffer));
	}

	public void SetPipeline (Pipeline pipeline)
	{
		this.mCommands.Add(.SetPipeline(pipeline));
	}

	public void SetResourceSet (uint32 slot, ResourceSet set)
	{
		this.mCommands.Add(.SetResourceSet(slot, set));
	}

	public void SetResourceSetCompute (uint32 slot, ResourceSet set)
	{
		this.mCommands.Add(.SetResourceSetCompute(slot, set));
	}

	public void WaitFor (IResourceAlias resourceAlias)
	{
		this.mCommands.Add(.WaitFor(resourceAlias));
	}

	public void MakeAvailable (IResourceAlias resourceAlias)
	{
		this.mCommands.Add(.MakeAvailable(resourceAlias));
	}


}