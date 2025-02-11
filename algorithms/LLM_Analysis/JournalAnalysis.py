import numpy as np
import json
from sentence_transformers import SentenceTransformer
import faiss
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough

# TODO: Try to implement a different vector database 
# and implement a rag chain instead of a normal chain.

DIMENSIONS = 384
INDEX = faiss.IndexFlatL2(DIMENSIONS)
EMB_MODEL = SentenceTransformer('sentence-transformers/all-miniLM-L6-v2')
with open('tests/Emotions_dataset.json') as file:
    data = json.load(file)
embeddings = np.array(entry['embeddings'] for entry in data)
INDEX.add(embeddings)

def retrieve_similar(query, k=10):
    '''This function takes the user's query and returns the top k journal entries that are similar to the query.'''
    query_embedding = np.array(EMB_MODEL.encode(query)).reshape(1, -1)
    _, indices = INDEX.search(query_embedding, k)
    results = [{'journal_entry':data[i]['journal_entry'], 'emotion': data[i]['emotion'], 'sentiment_score':data[i]['sentiment_score']} for i in indices[0]]
    return results

# List of emotions to choose from
EMOTIONAL_STATES = ["Hopeful",
                     "Anxious", 
                     "Inspired", 
                     "Overwhelmed", 
                     "Peaceful", 
                     "Frustrated", 
                     "Curious", 
                     "Uncertain", 
                     "Hopelessness"]
# Template for the prompt
TEMPLATE = """Give the most relevant emotion to the following journal entry based on the sentiment score,
and the mapped emotions from the given context.
context: {context}
journal entry: {journal_entry}
Note: only choose from the following emotions and only output that emotion: {EMOTIONAL_STATES}"""

def Generate(query, context):
    '''This function takes the user's query and context and generates the most relevant emotion.'''
    # The following 3 lines of code sets the template for the prompt, 
    # initializes the LLM model, 
    # and chains the template and LLM model together with LangChain syntax.
    PROMPT = ChatPromptTemplate.from_template(TEMPLATE)
    LLM = ChatOpenAI(model_name = "gpt-4o-mini", temperature=0)
    CHAIN = PROMPT | LLM
    response = CHAIN.invoke({"context":context, "journal_entry":query, "EMOTIONAL_STATES":EMOTIONAL_STATES})
    return response.content