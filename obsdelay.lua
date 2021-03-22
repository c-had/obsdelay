obs = obslua

source_name = "Media Source"
delay = 233

function script_description()
  return string.format("Set audio delay for source %s to %d ms", source_name, delay)
end

function set_delay()
  local current_scene_as_source = obs.obs_frontend_get_current_scene()
  if current_scene_as_source then
    local current_scene = obs.obs_scene_from_source(current_scene_as_source)
    local scene_item = obs.obs_scene_find_source_recursive(current_scene, source_name)
    if scene_item then
      local item_source = obs.obs_sceneitem_get_source(scene_item)
      obs.obs_source_set_sync_offset(item_source, delay * 1000000)
      print(string.format("Sync offset: %d", obs.obs_source_get_sync_offset(item_source)/1000000))
    end
    obs.obs_source_release(current_scene_as_source)
  end
end

function on_delay_hotkey(pressed)
  if pressed then
    set_delay()
  end
end

hotkey_id = obs.OBS_INVALID_HOTKEY_ID

function script_load(settings)
  hotkey_id = obs.obs_hotkey_register_frontend(script_path(), string.format("Delay %d", delay), on_delay_hotkey)
  local hotkey_save_array = obs.obs_data_get_array(settings, string.format("delay_%d_hotkey", delay))
  obs.obs_hotkey_load(hotkey_id, hotkey_save_array)
  obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
  local hotkey_save_array = obs.obs_hotkey_save(hotkey_id)
  obs.obs_data_set_array(settings, string.format("delay_%d_hotkey", delay), hotkey_save_array)
  obs.obs_data_array_release(hotkey_save_array)
end

