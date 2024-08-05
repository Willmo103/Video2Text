import os
import ffmpeg
import whisper
import yaml
import sqlite3
from datetime import datetime
import argparse

CONFIG_PATH = os.path.join(os.path.expanduser(
    "~"), "Videos", "vid2text", "config.yml")


def load_config():
    with open(CONFIG_PATH, "r") as f:
        return yaml.safe_load(f)


def save_config(config):
    with open(CONFIG_PATH, "w") as f:
        yaml.safe_dump(config, f)


def init_db(db_path):
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute(
            """
        CREATE TABLE IF NOT EXISTS transcriptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            video_path TEXT,
            audio_path TEXT,
            transcript_path TEXT,
            timestamp TEXT
        );
        """
        )
        conn.commit()


def extract_audio(video_path, audio_output_path):
    ffmpeg.input(video_path).output(audio_output_path).run()


def transcribe_audio(audio_path):
    model = whisper.load_model("base")
    result = model.transcribe(audio_path)
    return result["text"]


def store_transcription_info(db_path, video_path, audio_path, transcript_path):
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute(
            """
        INSERT INTO transcriptions (video_path, audio_path, transcript_path, timestamp)
        VALUES (?, ?, ?, ?)
        """,
            (video_path, audio_path, transcript_path, datetime.now().isoformat()),
        )
        conn.commit()


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
    elif key.lower() == "exit":
        return
    else:
        print("Invalid key.")
    update_config()


def main():
    config = load_config()

    parser = argparse.ArgumentParser(
        description="Video to Text Transcription Tool")
    parser.add_argument("-v", "--video", help="Path to the input video file")
    parser.add_argument(
        "-u", "--update", action="store_true", help="Update configuration settings"
    )

    args = parser.parse_args()

    if args.update:
        update_config()
        return

    video_path = args.video
    output_dir = config["output_directory"]
    db_path = config["db_path"]

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    init_db(db_path)

    audio_path = os.path.join(
        output_dir, os.path.splitext(os.path.basename(video_path))[0] + ".wav"
    )
    transcript_path = os.path.join(
        output_dir, os.path.splitext(os.path.basename(video_path))[0] + ".txt"
    )

    extract_audio(video_path, audio_path)
    transcript = transcribe_audio(audio_path)

    with open(transcript_path, "w") as f:
        f.write(transcript)

    store_transcription_info(db_path, video_path, audio_path, transcript_path)


if __name__ == "__main__":
    main()
