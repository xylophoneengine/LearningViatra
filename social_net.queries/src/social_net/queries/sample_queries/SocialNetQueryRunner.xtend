package social_net.queries.sample_queries

import org.eclipse.equinox.app.IApplication
import org.eclipse.equinox.app.IApplicationContext
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.viatra.query.runtime.emf.EMFScope
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.URI
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.emf.ecore.resource.Resource
import java.util.regex.Matcher

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
		//sample_headless_query_sequence()
		sample_dynamic_headless_query_sequence()
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
	
	private def EMFScope dynamic_init(Resource rs){
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
		var User_subscribed_to.Matcher matcher =
			User_subscribed_to.Matcher.on(engine);
		// Get and iterate over all matches
		println(System.lineSeparator + "Query results:")
		for (match : matcher.getAllMatches())
			//match is of type ListUsers.Match
			println(match.getU1.user_name + " is subscribed to " + match.u2.user_name)
		println()
	}

	private def transitive_closure_test(ViatraQueryEngine engine){
		var Proper_transitive_closure.Matcher matcher = 
		Proper_transitive_closure.Matcher.on(engine)
		println(System.lineSeparator + "Query results transitive closure:")
		for (match : matcher.getAllMatches()){
			//match is of type ListUsers.Match
			println(match.getU1().user_name + "-->" +  match.getU2.user_name)
			}
		println()
	}
	
		private def weird_transitive_closure_test(ViatraQueryEngine engine){
		var Weird_transitive_closure.Matcher matcher = 
		Weird_transitive_closure.Matcher.on(engine)
		println(System.lineSeparator + "Query results of weird transitive closure:")
		for (match : matcher.getAllMatches()){
			//match is of type ListUsers.Match
			println(match.getU1().user_name + "-->" +  match.getU2.user_name)
			}
		println()
	}

	def private sample_headless_query_sequence(){
		val scope = initializeModelScope(
			"/social_net/social_net/example_net.social_net"
		)
		val query_engine = prepareQueryEngine(scope)
		printAllMatches(query_engine)
		transitive_closure_test(query_engine)
		weird_transitive_closure_test(query_engine)
	}
	
	def private sample_dynamic_headless_query_sequence(){
		var model_generator = new ModelGenerator("dynamic_sample")
		val scope = dynamic_init(model_generator.create_sample_net())
		val query_engine = prepareQueryEngine(scope)
		var User_subscribed_to.Matcher matcher =
			User_subscribed_to.Matcher.on(query_engine);
		// Get and iterate over all matches
		println(System.lineSeparator + "Query results:")
		for (match : matcher.getAllMatches())
			//match is of type ListUsers.Match
			println(match.getU1.user_name + " is subscribed to " + match.u2.user_name)
		println()
		var user_1 = model_generator.create_user("num1", new Long(376245))
		var user_2 = model_generator.create_user("num2", new Long(28338))
		model_generator.subscribe_u1_to_u2(user_1, user_2)
		for (match : matcher.getAllMatches())
			//match is of type ListUsers.Match
			println(match.getU1.user_name + " is subscribed to " + match.u2.user_name)
		println()
		
		var Match_users_and_age.Matcher m = Match_users_and_age.Matcher.on(query_engine)
		for (match : m.getAllMatches())
			//match is of type ListUsers.Match
			println(match.u.user_name + " is " + match.l + "old")
		println()
	}
}