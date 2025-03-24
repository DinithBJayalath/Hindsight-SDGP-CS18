import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';
// import * as fs from 'fs';

const PROTO_PATH = './algorithms.proto';
const packageDefinition = protoLoader.loadSync(PROTO_PATH);
const algorithmsProto: any = grpc.loadPackageDefinition(packageDefinition).algorithms;
// const rootCert = fs.readFileSync("../resources/ca.crt");
// const clientCert = fs.readFileSync("../resources/client.crt");
// const clientKey = fs.readFileSync("../resources/client.key");
// const sslCreds = grpc.credentials.createSsl(rootCert, clientKey, clientCert);

const client = new algorithmsProto.JournalAnalyzer(
  'hindsight-algo-grpc-108992851524.asia-south1.run.app:443',
  grpc.credentials.createInsecure(),
  // sslCreds
);

export function analyze(query: string): Promise<string> {
  return new Promise((resolve, reject) => {
    client.analyze({ query: query }, (err: any, response: any) => {
      if (err) {
        reject(err);
      } else {
        resolve(response.response);
      }
    });
  });
}
