FROM node:11-alpine as base
WORKDIR /bmpp

COPY package.json .
COPY package-lock.json .

## Builder
FROM base as builder
RUN npm install -g npm
RUN npm install --only=production
RUN cp -R node_modules prod_node_modules
RUN apk --no-cache --virtual build-dependencies add \
    python \
    make \
    g++ \
    && npm install \
    && apk del build-dependencies
COPY . .
RUN npm run build

# Test Image
FROM builder as test
RUN npm run lint
RUN npm run test

# Release
FROM base as release
COPY --from=builder /bmpp/prod_node_modules ./node_modules
COPY --from=builder /bmpp/dist ./dist

ENTRYPOINT [ "npm", "run" , "serve" ]