from openai import OpenAI, api_key
import os

# api_key = os.getenv("OPENAI_API_KEY")
# print(api_key)

client = OpenAI()

EMOTIONAL_STATES = ["Hopeful", "Anxious", "Inspired", "Overwhelmed", "Peaceful", "Frustrated", "Curious", "Uncertain"]

# prompt = input("Write your thoughts: ")
prompt = '''The weight of unspoken emotions feels heavy today. I miss connection, real, deep conversations that go beyond surface-level small talk.
        I'm slowly understanding that self-compassion is more important than perfection. Family dynamics are complex. 
        Today's conversation with my parents reminded me that healing is a continuous process.'''
        #Overwhelmed

response = client.chat.completions.create(
    model="gpt-4o-mini",  # Specify the model
    messages=[
        {"role": "system", "content": f"A helpful assistant to mental health professionals. Only output the most relevant emotion from this list {EMOTIONAL_STATES} with a confidence score"},
        {"role": "user", "content": prompt},
    ],
    max_tokens = 100,
)

print(response.choices[0].message.content)