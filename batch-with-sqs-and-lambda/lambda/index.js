import { S3, GetObjectCommand, PutObjectCommand } from "@aws-sdk/client-s3";
import sharp from "sharp";

const OUTPUT_BUCKET = process.env.OUTPUT_BUCKET;

const s3 = new S3();

export const handler = async (event) => {
  const s3Event = JSON.parse(event.Records[0].body);
  const bucket = s3Event.Records[0].s3.bucket.name;
  const key = s3Event.Records[0].s3.object.key;

  const { Body } = await s3.send(
    new GetObjectCommand({
      Bucket: bucket,
      Key: key,
    }),
  );

  const buf = Buffer.from(await Body.transformToByteArray());

  await s3.send(
    new PutObjectCommand({
      Bucket: OUTPUT_BUCKET,
      Key: key,
      Body: await sharp(buf).resize(512, 512, { fit: "contain" }).toBuffer(),
      ContentType: "image/jpeg",
    }),
  );
};
