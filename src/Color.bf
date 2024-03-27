namespace System.Math;


using System;
using System.Diagnostics;


[CRepr, Ordered, Packed, Union]
public struct Color
{
	static readonly public Color red => Color(1F, 0F, 0F, 1F);
	static readonly public Color green => Color(0F, 1F, 0F, 1F);
	static readonly public Color blue => Color(0F, 0F, 1F, 1F);
	static readonly public Color white => Color(1F, 1F, 1F, 1F);
	static readonly public Color black => Color(0F, 0F, 0F, 1F);
	static readonly public Color orange => Color(1F, 0.6470F, 0F, 1F);
	static readonly public Color transparent => Color(0.0F);

	static public Color kurzgesagt0 = 0xe03aa8FF;
	static public Color kurzgesagt1 = 0x3dca7bFF;
	static public Color kurzgesagt2 = 0xf58d35FF;
	static public Color kurzgesagt3 = 0xe9ddffFF;
	static public Color kurzgesagt4 = 0x4f00c8FF;
	static public Color kurzgesagt5 = 0x7115ffFF;
	static public Color kurzgesagt6 = 0xe23fafFF;


	public float[4] values;


	public float r
	{
		get { return this.values[0]; }
		set mut { this.values[0] = value; }
	}


	public float g
	{
		get { return this.values[1]; }
		set mut { this.values[1] = value; }
	}


	public float b
	{
		get { return this.values[2]; }
		set mut { this.values[2] = value; }
	}


	public float a
	{
		get { return this.values[3]; }
		set mut { this.values[3] = value; }
	}


	/*public this (Vector3 v)
	{
		this.values = float[4](v.x, v.y, v.z, 1.0F);
	}*/


	public this (float all)
	{
		this.values = float[4](all, all, all, all);
	}


	public this (float r, float g, float b, float a)
	{
		this.values[0] = r;
		this.values[1] = g;
		this.values[2] = b;
		this.values[3] = a;
	}


	public this (float rgb, float a)
	{
		this.values[0] = rgb;
		this.values[1] = rgb;
		this.values[2] = rgb;
		this.values[3] = a;
	}


	static public Color Lerp (Color a, Color b, float alpha)
	{
		float oneMinusAlpha = 1.0F - alpha;
		return Color(
			a.values[0] * oneMinusAlpha + b.values[0] * alpha,
			a.values[1] * oneMinusAlpha + b.values[1] * alpha,
			a.values[2] * oneMinusAlpha + b.values[2] * alpha,
			a.values[3] * oneMinusAlpha + b.values[3] * alpha
		);
	}


	static public operator Color (uint32 value)
	{
		uint8 r = uint8((value & 0xFF000000) >> 24);
		uint8 g = uint8((value & 0x00FF0000) >> 16);
		uint8 b = uint8((value & 0x0000FF00) >> 8);
		uint8 a = uint8(value & 0x000000FF);

		return Color(
			float(r) / 255F,
			float(g) / 255F,
			float(b) / 255F,
			float(a) / 255F
		);
	}


	static public Color operator - (Color lhs, Color rhs)
	{
		return Color(
			Math.Clamp(lhs.r - rhs.r, 0.0F, 1.0F),
			Math.Clamp(lhs.g - rhs.g, 0.0F, 1.0F),
			Math.Clamp(lhs.b - rhs.b, 0.0F, 1.0F),
			Math.Clamp(lhs.a - rhs.a, 0.0F, 1.0F)
		);
	}


	override public void ToString (String buffer)
	{
		uint8 r = uint8(this.r * 255);
		uint8 g = uint8(this.g * 255);
		uint8 b = uint8(this.b * 255);
		uint8 a = uint8(this.a * 255);
		buffer.AppendF("Color({}, {}, {}, {})", r, g, b, a);
	}

	static public Color Random (Random random)
	{
		switch (random.Next(0, 12))
		{
		case 00: return Self.red;
		case 01: return Self.green;
		case 02: return Self.blue;
		case 03: return Self.white;
		case 04: return Self.black;
		case 05: return Self.orange;
		case 06: return Self.kurzgesagt0;
		case 07: return Self.kurzgesagt1;
		case 08: return Self.kurzgesagt2;
		case 09: return Self.kurzgesagt3;
		case 10: return Self.kurzgesagt4;
		case 11: return Self.kurzgesagt5;
		default: return Self.kurzgesagt6;	
		}
	}

	static public Color FromUint8 (uint8 r, uint8 g, uint8 b, uint8 a)
	{
	 	return Color(
			float(r) / 255F,
			float(g) / 255F,
			float(b) / 255F,
			float(a) / 255F
		);
	}
}


namespace System;

using System.Math;

extension Random
{
	public Color NextColor ()
	{
		return Color(
			float(this.Next(0, 255)) / 255F,
			float(this.Next(0, 255)) / 255F,
			float(this.Next(0, 255)) / 255F,
			1F
		);
	}
}