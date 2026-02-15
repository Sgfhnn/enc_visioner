from PIL import Image, ImageDraw, ImageFont

# Create a 1024x1024 image
size = (1024, 1024)
# Deep Navy Background #1A1A2E
bg_color = (26, 26, 46) 
# Vibrant Green #00C853
green_color = (0, 200, 83)
# Gold #FFD600
gold_color = (255, 214, 0)

img = Image.new('RGB', size, color=bg_color)
draw = ImageDraw.Draw(img)

# Draw a stylized banknote shape (rounded rectangle)
margin = 200
rect = [margin, 350, size[0] - margin, 674]
draw.rounded_rectangle(rect, radius=60, fill=green_color)

# Draw a circle in the center (gold)
center = (size[0] // 2, size[1] // 2)
radius = 120
draw.ellipse([center[0] - radius, center[1] - radius, center[0] + radius, center[1] + radius], fill=gold_color)

# Save the image
img.save('assets/icon/app_icon.png')
print("Icon generated successfully.")
