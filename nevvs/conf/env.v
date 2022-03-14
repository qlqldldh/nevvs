module conf

import os

const max_env_cfg_size = 1000

fn open_env_cfg(stage string) ?os.File {
	return os.open(".env.$stage")
}

fn load_raw_env_cfg(stage string) ?string {
	mut env_file := open_env_cfg(stage) or {
		return error("ERROR: opening env file failed")
	}
	defer {
		env_file.close()
	}

	mut env_cfg_raw := []byte{len: max_env_cfg_size, init: "".byte()}
	if env_file.read(mut env_cfg_raw)? == 0 {
		return error("ERROR: env file is empty")
	}

	return env_cfg_raw.filter(it != "".byte()).bytestr()
}

fn parse_raw_env_cfg(env_cfg_raw string) map[string]string {
	mut arr := []byte{}
	mut result := map[string]string{}
	mut key_value := []string{len: 2} // how to do 'Destructuring' in V??

	for ch in env_cfg_raw {
		if arr.len != 0 && ch.ascii_str() == "\n" {
			key_value = arr.map(it.ascii_str()).join("").split("=")
			result[key_value[0]] = key_value[1]
			arr.clear()
			continue
		}
		arr << ch
	}

	return result
}

pub fn set_env_cfg(stage string) ? {
	env_cfg_raw := load_raw_env_cfg(stage)?
	cfg_map := parse_raw_env_cfg(env_cfg_raw)
	mut res_code := 0

	for name, value in cfg_map {
		res_code = os.setenv(name, value, true)
		if res_code == -1 {
			return error("ERROR: Fail to set env config.")
		}
	}
}
