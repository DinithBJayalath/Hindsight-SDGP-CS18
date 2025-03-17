import grpc
from concurrent import futures
import algorithms_pb2 as algorithms_pb2
import algorithms_pb2_grpc as algorithms_pb2_grpc
from LLM_Analysis.JournalAnalysis import Generate

class JournalAnalyzer(algorithms_pb2_grpc.JournalAnalyzerServicer):
    def analyze(self, request, context):
        result = Generate(request.query)
        print(result)
        emotion, sentiment_score = result.split("," , 1)
        if ":" in emotion:
            emotion = emotion.split(":", 1)[1].strip()
            sentiment_score = sentiment_score.split(":", 1)[1].strip()
        print(f"Emotional analysis of journal entry is: {emotion}, Sentiment score is: {sentiment_score}")
        return algorithms_pb2.AnalyzeResponse(response = emotion)

# SSL/TLS, uncomment to enable
# with open("resources/server.key", "rb") as f:
#     private_key = f.read()
# with open("resources/server.crt", "rb") as f:
#     certificate_chain = f.read()
# with open("resources/ca.crt", "rb") as f:
#     ca_cert = f.read()
# server_credentials = grpc.ssl_server_credentials(
#     ((private_key, certificate_chain,),),
#     root_certificates=ca_cert,
#     require_client_auth=True
# )
def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    algorithms_pb2_grpc.add_JournalAnalyzerServicer_to_server(JournalAnalyzer(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    print("Server started at port 50051")
    server.wait_for_termination()

if __name__ == "__main__":
    serve()