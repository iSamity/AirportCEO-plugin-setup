using BepInEx.Configuration;

namespace TemplateSource.Config;

/// <summary>
/// Central place for BepInEx <see cref="ConfigFile"/> options. Add <see cref="ConfigFile.Bind{T}"/> calls
/// and matching properties here — see <c>Config/README.md</c> for an example.
/// </summary>
public sealed class DefaultConfig
{
    // Example property (pair with Setup function) so you can reference it later in the plugin:
    // public ConfigEntry<bool> MySetting { get; }

    public void Setup(ConfigFile config)
    {
        // Example (uncomment and adapt):
        // MySetting = config.Bind("General", "MySetting", true, "Description shown in the .cfg file and config UIs.");
    }

}
