using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace DevelopmentTestServer {
	public static class Startup {
		[STAThread]
		static void Main() {
			// (Uncomment line to start server and make it simulate the user 'bob' connecting for 30 seconds)
			// (this is an easy way to debug serverside code)
			//
			// PlayerIO.DevelopmentServer.Server.StartWithDebugging("<Enter your gameid here>", "public", "MyCode", "bob", "", 30000);

			// Start the server and wait for incomming connection
			PlayerIO.DevelopmentServer.Server.StartWithDebugging();

			// BE ADVISED: this project will build/run properly under the following conditions:
			// - Rider EAP w/ Mono 3.4.0 (2.11 will fail, 4.x will disconnect users right after connect)
			// - MonoDevelop w/ Mono 2.10.12 (Unity MonoDevelop)
			// - VisualStudio
		}
	}
}
