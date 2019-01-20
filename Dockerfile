FROM node:10-alpine as base
WORKDIR /bmpp

COPY package.json .

## Builder
FROM base as builder
RUN npm install --only=production
RUN cp -R node_modules prod_node_modules
RUN npm install
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