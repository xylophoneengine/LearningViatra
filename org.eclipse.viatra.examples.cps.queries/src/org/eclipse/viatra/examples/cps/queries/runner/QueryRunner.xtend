package org.eclipse.viatra.examples.cps.queries.runner

import org.eclipse.equinox.app.IApplication
import org.eclipse.equinox.app.IApplicationContext
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.viatra.query.runtime.emf.EMFScope
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.URI
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.examples.cps.queries.CPSQueries
import org.eclipse.viatra.examples.cps.queries.List_all_hosts_and_their_ip_addr

/*
 * step 1) add the dependency to the MANIFEST.MF
 * 	- org.eclipse.core.runtime
 * step 2) add the application extension point in plugin.xml
<extension id="queryrunner" point="org.eclipse.core.runtime.applications">
	<application cardinality="singleton-global" thread="main" visible="true">
		<run class="org.eclipse.viatra.examples.cps.queries.runner.QueryRunner"/>
	/application>
</extension> 
 * step 3) configure "Run As" to run as an application and not java class
 */
class QueryRunner implements IApplication {
	
	override start(IApplicationContext context) throws Exception {
		println("application starting")
		sample_headless_query_sequence()
		return 0;
	}
	
	override stop() {
		println("Application stopped")
	}
	
	private def EMFScope initializeModelScope(String fqdn_model_location) {
		var ResourceSet rs = new ResourceSetImpl();
		rs.getResource(
			URI.createPlatformPluginURI(
				fqdn_model_location,
				true),
			true
		);
		return new EMFScope(rs);
	}
	
	private def ViatraQueryEngine prepareQueryEngine(EMFScope scope) {
		//Access managed query engine
	    var ViatraQueryEngine engine = ViatraQueryEngine.on(scope);
	    //Initialize all queries on engine
		CPSQueries.instance().prepare(engine);
		return engine;
	}

	private def printAllMatches(ViatraQueryEngine engine) {
		var List_all_hosts_and_their_ip_addr.Matcher matcher =
			List_all_hosts_and_their_ip_addr.Matcher.on(engine);
		// Get and iterate over all matches
		println(System.lineSeparator + "Query results:")
		for (match : matcher.getAllMatches())
			//match is of type List_all_hosts_and_their_ip_addr.Match
			println(match.getH())
		println()
	}

	def private sample_headless_query_sequence(){
		val scope = initializeModelScope(
"/org.eclipse.viatra.examples.cps.queries/src/org/eclipse/viatra/examples/cps/queries/models/example.cyberphysicalsystem"
		)
		val query_engine = prepareQueryEngine(scope)
		printAllMatches(query_engine)
	}
}