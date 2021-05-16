package social_net.queries.sample_queries

import org.eclipse.equinox.app.IApplication
import org.eclipse.equinox.app.IApplicationContext
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.viatra.query.runtime.emf.EMFScope
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.URI
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine


/*
 * step 1) add the dependency to the MANIFEST.MF
 * 	- org.eclipse.core.runtime
 * step 2) add the application extension point in plugin.xml
<extension id="SocialNetQueryRunner" point="org.eclipse.core.runtime.applications">
	<application cardinality="singleton-global" thread="main" visible="true">
		<run class="social_net.queries.sample_queries.SocialNetQueryRunner"/>
	/application>
</extension> 
 * step 3) configure "Run As" to run as an application and not java class
 */
class SocialNetQueryRunner implements IApplication {
	
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
		SocialNetQueries.instance().prepare(engine);
		return engine;
	}

	private def printAllMatches(ViatraQueryEngine engine) {
		var ListUsers.Matcher matcher =
			ListUsers.Matcher.on(engine);
		// Get and iterate over all matches
		println(System.lineSeparator + "Query results:")
		for (match : matcher.getAllMatches())
			//match is of type ListUsers.Match
			println(match.getU())
		println()
	}

	def private sample_headless_query_sequence(){
		val scope = initializeModelScope(
			"/social_net/social_net/example_net.social_net"
		)
		val query_engine = prepareQueryEngine(scope)
		printAllMatches(query_engine)
	}
}