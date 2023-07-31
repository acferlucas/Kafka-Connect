CREATE STREAM USUARIO_STREAM (
  AFTER STRUCT< NOME VARCHAR,
  SENHA VARCHAR >
) WITH (
  KAFKA_TOPIC='postgresql.public.user',
  VALUE_FORMAT='JSON'
);

SELECT
  *
FROM
  USUARIO_STREAM_T1 EMIT CHANGES;

CREATE STREAM USUARIO_SINK_STREAM AS
SELECT
  AFTER->NOME AS USER_NAME,
  AFTER->SENHA AS USER_PASS
FROM USUARIO_STREAM;

CREATE SINK CONNECTOR USUARIO_SINK WITH (
  'connector.class' = 'org.apache.kafka.connect.file.FileStreamSinkConnector',
  'file' = '/tmp/usuario_sink_stream.json',
  'format' = 'json',
  'topics' = 'USUARIO_SINK_STREAM'
);