FROM node:12-alpine as base
WORKDIR /bmpp

RUN apk add --update yarn
COPY package.json .

## Builder
FROM base as builder

RUN yarn install --production
RUN cp -r node_modules prod_node_modules
RUN yarn install
COPY . .
RUN yarn run build

# Test Image
FROM builder as test
RUN yarn run lint
RUN yarn run test

# Release
FROM base as release
COPY --from=builder /bmpp/prod_node_modules ./node_modules
COPY --from=builder /bmpp/dist ./dist

ENTRYPOINT [ "yarn", "run" , "serve" ]
