# vid2text/cli.py
import argparse
import os
from vid2text import core, utils


def main():
    parser = argparse.ArgumentParser(
        description='Video to Text Transcription Tool')
    parser.add_argument(
        '-v', '--video', help='Path to the input video file', required=True)
    parser.add_argument('-u', '--update', action='store_true',
                        help='Update configuration settings')

    args = parser.parse_args()

    if args.update:
        utils.update_config()
        return

    video_path = args.video
    config = utils.load_config()
    output_dir = config['output_directory']
    db_path = config['db_path']

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    audio_path = os.path.join(output_dir, os.path.splitext(
        os.path.basename(video_path))[0] + '.wav')
    transcript_path = os.path.join(output_dir, os.path.splitext(
        os.path.basename(video_path))[0] + '.txt')

    core.extract_audio(video_path, audio_path)
    transcript = core.transcribe_audio(audio_path)

    with open(transcript_path, 'w') as f:
        f.write(transcript)

    core.store_transcription_info(
        db_path, video_path, audio_path, transcript_path)


if __name__ == '__main__':
    main()
