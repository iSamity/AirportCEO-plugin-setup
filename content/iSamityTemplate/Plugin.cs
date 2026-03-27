using BepInEx;
using BepInEx.Logging;
//#if (WithConfig == true)
using BepInEx.Configuration;
using TemplateSource.Config;
//#endif

namespace TemplateSource;

[BepInPlugin(MyPluginInfo.PLUGIN_GUID, MyPluginInfo.PLUGIN_NAME, MyPluginInfo.PLUGIN_VERSION)]
public class Plugin : BaseUnityPlugin
{
    internal static new ManualLogSource Logger;
//#if (WithConfig == true)
    internal static ConfigFile ConfigReference { get; private set; }

    private readonly DefaultConfig _defaultConfig = new();
//#endif

    private void Awake()
    {
        // Plugin startup logic
        Logger = base.Logger;
//#if (WithConfig == true)
        ConfigReference = base.Config;

        _defaultConfig.Setup(Config);
//#endif

        SetupHarmony();

        Logger.LogInfo($"Plugin {MyPluginInfo.PLUGIN_GUID} is loaded!");
    }

    private void Start()
    {
        SetupModLoader();

        Logger.LogInfo($"Plugin {MyPluginInfo.PLUGIN_NAME} - Finished start");
    }

    private void SetupHarmony()
    {
        Logger.LogInfo($"Plugin {MyPluginInfo.PLUGIN_NAME} - Setting up Harmony.");

        var harmony = new HarmonyLib.Harmony(MyPluginInfo.PLUGIN_GUID);
        harmony.PatchAll();

        Logger.LogInfo($"Plugin {MyPluginInfo.PLUGIN_NAME} - Finished up Harmony.");
    }

    private void SetupModLoader()
    {
        Logger.LogInfo($"Plugin {MyPluginInfo.PLUGIN_NAME} - Setting up Mod Loader.");

        // TODO: You decide if you want to add the watermark to the release
#if DEBUG
        WatermarkUtils.Register(new WatermarkInfo(MyPluginInfo.PLUGIN_NAME, MyPluginInfo.PLUGIN_VERSION, false));
// #else
//         WatermarkUtils.Register(new WatermarkInfo(#SHORTER_VERSION_OF_YOUR_PLUGIN, MyPluginInfo.PLUGIN_VERSION, true));
#endif
    }

}
