#include "files.2/files.h"
#include "vec.h"
#include "str.h"
#include "debug.h"

namespace fxkeyd
{
    std::string _configPath = "/etc/keyd/devices_ignored";
    ml::Vec<std::string> _to_ignore;
    bool _config_exists = false;
    bool _config_exists_checked = false;
    bool _loaded = false;

    bool config_exists()
    {
        if (_config_exists_checked)
            return _config_exists;
        _config_exists = files::exists(_configPath);
        if (_config_exists)
            lg("config exists");
        else
            lg("config does not exist");
        _config_exists_checked = true;
        return _config_exists;
    }

    void load_config()
    {
        if (_loaded)
            return;
        if (!config_exists())
            return;
        auto data = files::read(_configPath);
        lg("config data loaded : ");
        lg(data);
        _to_ignore = str::split(data, "\n");
        _loaded = true;
    }

    bool is_ignored(const std::string &device)
    {
        load_config();
        return _to_ignore.contains(device);
    }
}

extern "C"
{
    int device_is_ignored(const char *device)
    {
        return fxkeyd::is_ignored(device);
    }
}
