# vid2text/utils.py
import yaml
import os

CONFIG_PATH = os.path.join(os.path.expanduser(
    "~"), "Videos", "vid2text", "config.yml")


def load_config():
    with open(CONFIG_PATH, 'r') as f:
        return yaml.safe_load(f)


def save_config(config):
    with open(CONFIG_PATH, 'w') as f:
        yaml.safe_dump(config, f)


def update_config():
    config = load_config()
    print("Current Configuration:")
    for key, value in config.items():
        print(f"{key}: {value}")
    key = input(
        "Enter the key you want to update (or 'exit' to finish): ").strip()
    if key in config:
        new_value = input(f"Enter the new value for {key}: ").strip()
        config[key] = new_value
        save_config(config)
        print(f"Updated {key} to {new_value}")
    elif key.lower() == 'exit':
        return
    else:
        print("Invalid key.")
    update_config()
