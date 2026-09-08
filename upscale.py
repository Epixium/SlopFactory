import os
from PIL import Image

input_dir = "./assets/1x/"
output_dir = "./assets/2x/"

os.makedirs(output_dir, exist_ok=True)

for filename in os.listdir(input_dir):
    if filename.endswith(".png"):
        if not os.path.exists(os.path.join(output_dir, filename)) or os.path.getmtime(os.path.join(output_dir, filename)) < os.path.getmtime(os.path.join(input_dir, filename)):
            if os.path.exists(os.path.join(output_dir, filename)):
                os.remove(os.path.join(output_dir, filename))
                print(f"❌ Deleted 2x of {filename}")
            else:
                print(f"🫥 2x of {filename} already doesn't exist")
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(output_dir, filename)

            img = Image.open(input_path)
            scaled_img = img.resize((img.width * 2, img.height * 2), Image.NEAREST)
            scaled_img.save(output_path)

            print(f"✅ Upscaled {filename} to 2x")
        else:
            print(f"↪️ Ignored {filename} in 2x folder (1x hasn't been changed)")
    else:
        print(f"↪️ Ignored {filename} in 1x folder (not a PNG)")