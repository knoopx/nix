import sys
import numpy as np
from supertonic import TTS

tts = TTS(auto_download=True)
style = tts.get_voice_style(voice_name=sys.argv[1])
wav, _ = tts.synthesize(
    text=sys.argv[2], voice_style=style, lang="en", total_steps=int(sys.argv[3])
)
amplified = wav.squeeze() * float(sys.argv[4])
samples = (np.tanh(amplified) * 32767).astype("int16")
sys.stdout.buffer.write(samples.tobytes())
