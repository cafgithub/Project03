// Client.cpp example
#include "HelloC.h"
#include "orbsvcs/CosNamingC.h"
#include "ace/Log_Msg.h"

int main(int argc, char* argv[]) {
    try {
        CORBA::ORB_var orb = CORBA::ORB_init(argc, argv);
        
        // Get Naming Service reference
        CORBA::Object_var naming_obj = orb->resolve_initial_references("NameService");
        CosNaming::NamingContext_var naming_context = 
            CosNaming::NamingContext::_narrow(naming_obj.in());
        
        // Find the HelloService
        CosNaming::Name name;
        name.length(1);
        name[0].id = CORBA::string_dup("HelloService");
        name[0].kind = CORBA::string_dup("");
        
        CORBA::Object_var hello_obj = naming_context->resolve(name);
        Hello::HelloService_var hello = Hello::HelloService::_narrow(hello_obj.in());
        
        // Call both methods
        char* message = hello->sayHello();
        ACE_DEBUG((LM_INFO, "Server says: %s\n", message));
        CORBA::string_free(message);
        
        char* datetime = hello->getCurrentDateTime();
        ACE_DEBUG((LM_INFO, "Current Date/Time: %s\n", datetime));
        CORBA::string_free(datetime);
        
        orb->destroy();
        
    } catch (const CORBA::Exception& ex) {
        ACE_ERROR((LM_ERROR, "CORBA Exception: %s\n", ex._info().c_str()));
        return 1;
    }
    return 0;
}