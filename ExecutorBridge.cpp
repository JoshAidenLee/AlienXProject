#include <string>
#include <vector>
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <sys/mman.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

extern "C" {
    const char* execute_lua(const char* script) {
        std::string result = "Executed: ";
        result += script;
        
        char* output = (char*)malloc(result.length() + 1);
        strcpy(output, result.c_str());
        return output;
    }
    
    bool inject_into_process(const char* script) {
        pid_t pid = getpid();
        if (pid == -1) return false;
        
        void* remote_mem = mmap(NULL, strlen(script), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
        if (remote_mem == MAP_FAILED) return false;
        memcpy(remote_mem, script, strlen(script));
        
        return true;
    }
}