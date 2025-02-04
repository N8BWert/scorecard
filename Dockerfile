# Copyright 2020 Security Scorecard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang@sha256:ea3d912d500b1ae0a691b2e53eb8a6345b579d42d7e6a64acca83d274b949740 AS base
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* ./
RUN go mod download
COPY . ./

FROM base AS build
ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 make build-scorecard

FROM gcr.io/distroless/base:nonroot@sha256:533c15ef2acb1d3b1cd4e58d8aa2740900cae8f579243a53c53a6e28bcac0684
COPY --from=build /src/scorecard /
ENTRYPOINT [ "/scorecard" ]
