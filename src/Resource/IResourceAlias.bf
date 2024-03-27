namespace System.Engine;


using System;
using System.Collections;
using System.Diagnostics;


interface IResourceAlias : IHashable
{
	StringView GetName ();
	StringView GetState ();
}