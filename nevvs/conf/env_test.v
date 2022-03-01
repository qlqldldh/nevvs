module conf

import os

const (
	stage = "test"
	file_path = os.getwd() + "/.env.$stage"
	cfg_contents = "USERNAME=test\nPASSWORD=testpwd\nEXAMPLE_NAME=env_test\n"
)

fn test_load_raw_env_cfg_with_invalid_stage_should_raise_error() {
	invalid_stage := "invalid"
	result := load_raw_env_cfg(invalid_stage) or {"error"}
	assert result == "error"
}

fn test_load_raw_env_cfg_with_empty_file_should_raise_error() {
	mut empty_file := os.create(file_path) or {panic("Fail to create a file")}
	defer {
		empty_file.close()
		os.execute_or_exit("rm $file_path")
	}

	result := load_raw_env_cfg(stage) or {"error"}
	assert result == "error"
}

fn test_load_raw_env_cfg_should_return_content_str() {
	mut env_cfg_file := os.create(file_path) or {panic("Fail to create a file")}
	defer {
		if env_cfg_file.is_opened {
			env_cfg_file.close()
		}

		os.execute_or_exit("rm $file_path")
	}
	env_cfg_file.write_string(cfg_contents) or {panic("Fail to write content to a file")}
	env_cfg_file.close()
	
	result := load_raw_env_cfg(stage) or {panic("fail to open file")}

	assert result == cfg_contents
}

fn test_parse_raw_env_cfg_should_return_cfg_map() {
	mut env_cfg_file := os.create(file_path) or {panic("Fail to create a file")}
	defer {
		if env_cfg_file.is_opened {
			env_cfg_file.close()
		}

		os.execute_or_exit("rm $file_path")
	}
	env_cfg_file.write_string(cfg_contents) or {panic("Fail to write content to a file")}
	env_cfg_file.close()

	result := parse_raw_env_cfg(cfg_contents)

	assert result["USERNAME"] == "test"
	assert result["PASSWORD"] == "testpwd"
	assert result["EXAMPLE_NAME"] == "env_test"
}

fn test_set_env_cfg() {
	mut env_cfg_file := os.create(file_path) or {panic("Fail to create a file")}
	defer {
		if env_cfg_file.is_opened {
			env_cfg_file.close()
		}

		os.execute_or_exit("rm $file_path")
		os.unsetenv("USERNAME")
		os.unsetenv("PASSWORD")
		os.unsetenv("EXAMPLE_NAME")
	}
	env_cfg_file.write_string(cfg_contents) or {panic("Fail to write content to a file")}
	env_cfg_file.close()

	result := set_env_cfg(stage) or {panic("fail to set env config.")}

	assert os.getenv("USERNAME") == "test"
	assert os.getenv("PASSWORD") == "testpwd"
	assert os.getenv("EXAMPLE_NAME") == "env_test"
}
