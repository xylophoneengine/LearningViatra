package social_net.model_gen;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Map;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import social_net.SocialNetwork;
import social_net.Social_netFactory;
import social_net.Topic;
import social_net.User;

public class ModelGenerator {
	
	private static final Social_netFactory net_factory = Social_netFactory.eINSTANCE;
	public Resource res; 
	
	public ModelGenerator(String file_name_without_file_extension) {
        Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
        Map<String, Object> m = reg.getExtensionToFactoryMap();
        m.put("social_net", new XMIResourceFactoryImpl());
        ResourceSet resSet = new ResourceSetImpl();
        this.res = resSet.createResource(URI.createURI("social_net/" + file_name_without_file_extension + ".social_net"));
	}
	
	public User create_user(String name) {
		User u = net_factory.createUser();
		u.setUser_name(name);
		return u;
	}
	
	public SocialNetwork create_net() {
		return net_factory.createSocialNetwork();
	}
	
	public Topic create_topic(String content) {
		Topic t = net_factory.createTopic();
		t.setContent(content);
		return t;
	}
	
	public void subscribe_u1_to_u2(User u1, User u2) {
		u1.getSubscribed_to_user().add(u2);
	}
	
	public void subscribe_u1_to_topic_t2(User u1, Topic t2) {
		u1.getSubscribed_to_topic().add(t2);
	}
	
	public void set_t1_as_super_of_t2(Topic t1, Topic t2) {
		t1.getSub_topic().add(t2);
		t2.getSuper_topic().add(t1);
	}
	
	public void save_resource() {
        try {
            this.res.save(Collections.EMPTY_MAP);
        } catch (IOException e) {
            e.printStackTrace();
        }
	}

	public void add_to_resource(EObject c) {
		this.res.getContents().add(c);
	}
	
	public static void create_sample_net() {
		ModelGenerator creator = new ModelGenerator("example_net");
		String[] names = {"Su", "Alice", "Bob", "Wei", "An", "Hina", "Ye", "Tang", "Bao", "Liu"};
		ArrayList<User> users = new ArrayList<>();
		ArrayList<Topic> topics = new ArrayList<>();

		for(int i = 0; i < 10 ; i++) {
			User u = creator.create_user(names[i]);
			Topic t = creator.create_topic("topic number: " + i);
			creator.subscribe_u1_to_topic_t2(u, t);
			users.add(u);
			topics.add(t);
		}
		creator.subscribe_u1_to_u2(users.get(1), users.get(2));
		creator.subscribe_u1_to_u2(users.get(2), users.get(3));
		creator.subscribe_u1_to_u2(users.get(2), users.get(6));
		creator.subscribe_u1_to_u2(users.get(2), users.get(0));
		creator.subscribe_u1_to_u2(users.get(3), users.get(8));
		SocialNetwork net = creator.create_net();
		net.getUser().addAll(users);
		net.getTopic().addAll(topics);
		creator.add_to_resource(net);
		creator.save_resource();
	}
	
	public static void main(String[] args) {
		create_sample_net();
		System.out.println("Test");
	}
}
