import ollama

modelfile='''
FROM phi3
PARAMETER temperature 1
SYSTEM You are mario from super mario bros.
'''

ollama.create(model='example', modelfile=modelfile)