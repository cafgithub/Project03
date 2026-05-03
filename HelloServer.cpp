#include "HelloS.h"
#include "orbsvcs/CosNamingC.h"
#include "ace/Log_Msg.h"

class HelloImpl : public POA_Hello {
public:
    virtual char* sayHello() override {
        return CORBA::string_dup("Hello from TAO Server registered with Central Naming Service! - CAF Merdoso");
    }
};

int main(int argc, char* argv[]) {
    try {
        CORBA::ORB_var orb = CORBA::ORB_init(argc, argv);
        
        CORBA::Object_var obj = orb->resolve_initial_references("RootPOA");
        PortableServer::POA_var root_poa = PortableServer::POA::_narrow(obj);
        
        HelloImpl* hello_impl = new HelloImpl();
        PortableServer::ObjectId_var oid = root_poa->activate_object(hello_impl);
        
        Hello_var hello = hello_impl->_this();
        
        PortableServer::POAManager_var poa_manager = root_poa->the_POAManager();
        poa_manager->activate();
        
        // Connect to the Naming Service
        CORBA::Object_var naming_obj = orb->resolve_initial_references("NameService");
        CosNaming::NamingContext_var naming_context = 
            CosNaming::NamingContext::_narrow(naming_obj.in());
        
        // Register this server
        CosNaming::Name name;
        name.length(1);
        name[0].id = CORBA::string_dup("HelloService");
        name[0].kind = CORBA::string_dup("");
        
        naming_context->rebind(name, hello.in());
        
        ACE_DEBUG((LM_INFO, "\n========================================\n"));
        ACE_DEBUG((LM_INFO, "✅ Server registered with Naming Service\n"));
        ACE_DEBUG((LM_INFO, "   Service Name: HelloService\n"));
        ACE_DEBUG((LM_INFO, "🟢 Server is running...\n"));
        ACE_DEBUG((LM_INFO, "========================================\n\n"));
        
        orb->run();
        
        hello_impl->_remove_ref();
        orb->destroy();
        
    } catch (const CORBA::Exception& ex) {
        ACE_ERROR((LM_ERROR, "CORBA Exception: %s\n", ex._info().c_str()));
        return 1;
    }
    return 0;
}
