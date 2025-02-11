import grpc
from concurrent import futures
import algorithms_pb2 as algorithms_pb2
import algorithms_pb2_grpc as algorithms_pb2_grpc
from LLM_Analysis.JournalAnalysis import retrieve_similar, Generate

class JournalAnalyzer(algorithms_pb2_grpc.JournalAnalyzerServicer):
    def analyze(self, request, context):
        results = retrieve_similar(request.query)
        emotion = Generate(request.query, results)
        print(f"Emotional analysis of journal entry is: {emotion}")
        return algorithms_pb2.AnalyzeResponse(response = emotion)

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    algorithms_pb2_grpc.add_JournalAnalyzerServicer_to_server(JournalAnalyzer(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    print("Server started at port 50051")
    server.wait_for_termination()

if __name__ == "__main__":
    serve()