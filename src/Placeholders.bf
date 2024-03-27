namespace System.Engine;


using System;
using System.Collections;
using System.Diagnostics;


class Framebuffer : IResource
{
	String mName;


	public this (StringView name)
	{
		this.mName = new String(name);
	}

	public ~this ()
	{
		DeleteAndNullify!(this.mName);
	}


	public StringView GetName ()
	{
		return this.mName;
	}


	public int GetHashCode ()
	{
		return HashCode.Generate(this);
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("{}(\"{}\")", nameof(Self), this.mName);
	}
}
class RenderPass : IResource
{
	String mName;


	public this (StringView name)
	{
		this.mName = new String(name);
	}

	public ~this ()
	{
		DeleteAndNullify!(this.mName);
	}


	public StringView GetName ()
	{
		return this.mName;
	}


	public int GetHashCode ()
	{
		return HashCode.Generate(this);
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("{}(\"{}\")", nameof(Self), this.mName);
	}
}
class Texture : IResource
{
	String mName;


	public this (StringView name)
	{
		this.mName = new String(name);
	}

	public ~this ()
	{
		DeleteAndNullify!(this.mName);
	}


	public StringView GetName ()
	{
		return this.mName;
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("{}(\"{}\")", nameof(Self), this.mName);
	}


	public int GetHashCode ()
	{
		return HashCode.Generate(this);
	}
}
class Buffer : IResource
{
	String mName;


	public this (StringView name)
	{
		this.mName = new String(name);
	}

	public ~this ()
	{
		DeleteAndNullify!(this.mName);
	}


	public StringView GetName ()
	{
		return this.mName;
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("{}(\"{}\")", nameof(Self), this.mName);
	}


	public int GetHashCode ()
	{
		return HashCode.Generate(this);
	}

	public enum IndexFormat
	{
		Uint32,
		Uint16
	}
}
class Pipeline : IResource
{
	String mName;


	public this (StringView name)
	{
		this.mName = new String(name);
	}

	public ~this ()
	{
		DeleteAndNullify!(this.mName);
	}


	public StringView GetName ()
	{
		return this.mName;
	}


	public int GetHashCode ()
	{
		return HashCode.Generate(this);
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("{}(\"{}\")", nameof(Self), this.mName);
	}
}
class ResourceSet : IResource
{
	String mName;


	public this (StringView name)
	{
		this.mName = new String(name);
	}

	public ~this ()
	{
		DeleteAndNullify!(this.mName);
	}


	public StringView GetName ()
	{
		return this.mName;
	}


	public int GetHashCode ()
	{
		return HashCode.Generate(this);
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("{}(\"{}\")", nameof(Self), this.mName);
	}
}
struct Viewport
{
	public float[4] mValues;
}