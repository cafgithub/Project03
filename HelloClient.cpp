#include "HelloC.h"
#include "orbsvcs/CosNamingC.h"
#include "ace/Log_Msg.h"

int main(int argc, char* argv[]) {
    try {
        CORBA::ORB_var orb = CORBA::ORB_init(argc, argv);
        
        // Connect to the Naming Service
        CORBA::Object_var naming_obj = orb->resolve_initial_references("NameService");
        CosNaming::NamingContext_var naming_context = 
            CosNaming::NamingContext::_narrow(naming_obj.in());
        
        // Look up the service
        CosNaming::Name name;
        name.length(1);
        name[0].id = CORBA::string_dup("HelloService");
        name[0].kind = CORBA::string_dup("");
        
        ACE_DEBUG((LM_INFO, "\n🔍 Looking up 'HelloService' from Central Naming Service...\n"));
        CORBA::Object_var obj = naming_context->resolve(name);
        Hello_var hello = Hello::_narrow(obj.in());
        
        if (CORBA::is_nil(hello)) {
            ACE_ERROR((LM_ERROR, "Failed to find HelloService\n"));
            return 1;
        }
        
        CORBA::String_var result = hello->sayHello();
        ACE_DEBUG((LM_INFO, "========================================\n"));
        ACE_DEBUG((LM_INFO, "📨 %s\n", result.in()));
        ACE_DEBUG((LM_INFO, "========================================\n\n"));
        
        orb->destroy();
        
    } catch (const CORBA::Exception& ex) {
        ACE_ERROR((LM_ERROR, "CORBA Exception: %s\n", ex._info().c_str()));
        return 1;
    }
    return 0;
}
