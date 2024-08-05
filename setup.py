from setuptools import setup, find_packages

setup(
    name='vid2text',
    version='0.1.0',
    description='A tool for transcribing videos to text using Whisper',
    author='Will Morris',
    author_email='willmorris188.com',
    url='https://github.com/willmo103/vid2text',
    packages=find_packages(),
    install_requires=[
        'ffmpeg-python',
        'whisper',
        'pyyaml',
        'torch',
        'torchvision',
        'torchaudio'
    ],
    entry_points={
        'console_scripts': [
            'vid2text=vid2text.cli:main',
        ],
    },
)
