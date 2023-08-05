package JAVARuntime;

import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;
import org.luaj.vm2.lib.jse.JsePlatform;
import org.luaj.vm2.Globals;
import java.util.List;

public class LUAJUtils {
    
    public static Globals getGlobals()
    {
        Globals globals = JsePlatform.standardGlobals();

        for (int i = 0; i < JCompiler.engineClassCount(); i++)
        {
            JClass jClass = JCompiler.engineClassAt(i);
            Class<?> cls = jClass.getClassAddress();
            LuaValue test = CoerceJavaToLua.coerce(cls);
            globals.set(jClass.getName(), test);
        }

        for (int i = 0; i < JCompiler.userClassCount(); i++)
        {
            JClass jClass = JCompiler.userClassAt(i);
            Class<?> cls = jClass.getClassAddress();
            LuaValue test = CoerceJavaToLua.coerce(cls);
            globals.set(jClass.getName(), test);
        }

        return globals;
    }
}
