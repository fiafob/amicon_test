import json
import toml
import yaml
import os
import sys

def load_config(file_path):
    ext = os.path.splitext(file_path)[1].lower()
    
    if ext in ['.json']:
        with open(file_path, 'r') as f:
            return json.load(f), 'json'
    elif ext in ['.toml']:
        with open(file_path, 'r') as f:
            return toml.load(f), 'toml'
    elif ext in ['.yaml', '.yml']:
        with open(file_path, 'r') as f:
            return yaml.safe_load(f), 'yaml'
    else:
        raise ValueError(f"Неправильное расширение файла: {ext}")

def save_config(file_path, config_data, format_type):
    with open(file_path, 'w') as f:
        if format_type == 'json':
            json.dump(config_data, f, indent=4)
        elif format_type == 'toml':
            toml.dump(config_data, f)
        elif format_type == 'yaml':
            yaml.safe_dump(config_data, f)
        else:
            raise ValueError(f"Неправильное расширение файла: {format_type}")

def update_field(config_data, key, value):
    keys = key.split('.')
    d = config_data
    for k in keys[:-1]:
        if k not in d:
            d[k] = {}  
        d = d[k]
    d[keys[-1]] = value

def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <config_file> <key=value> ...")
        sys.exit(1)

    config_file = sys.argv[1]
    updates = sys.argv[2:]

    try:
        config_data, format_type = load_config(config_file)
    except ValueError as e:
        print(e)
        sys.exit(1)
    
    for update in updates:
        if '=' not in update:
            print(f"Неправильный формат кллючей: {update}. Expected key=value")
            continue
        key, value = update.split('=', 1)
        
        try:
            value = int(value)
        except ValueError:
            try:
                value = float(value)
            except ValueError:
                pass
        
        update_field(config_data, key, value)
    
    save_config(config_file, config_data, format_type)
    print(f"Файл конфигурации {config_file} успешно обновлен.")

if __name__ == "__main__":
    main()

