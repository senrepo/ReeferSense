# syntax=docker/dockerfile:1.4

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

ARG NUGET_AUTH_B64

COPY NuGet.config /src/NuGet.config
COPY iot-data-processor/iot-data-processor.csproj iot-data-processor/

RUN --mount=type=secret,id=nuget_auth \
    VSS_NUGET_EXTERNAL_FEED_ENDPOINTS="$(cat /run/secrets/nuget_auth)" && \
    echo "Auth JSON length: $(printf %s "$VSS_NUGET_EXTERNAL_FEED_ENDPOINTS" | wc -c)" && \
    dotnet restore iot-data-processor/iot-data-processor.csproj --configfile /src/NuGet.config

# Copy the rest and build
COPY . .
WORKDIR /src/iot-data-processor
ARG BUILD_CONFIGURATION=Release
RUN dotnet build "iot-data-processor.csproj" -c "$BUILD_CONFIGURATION" -o /app/build --no-restore

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "iot-data-processor.csproj" -c "$BUILD_CONFIGURATION" -o /app/publish --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","iot-data-processor.dll"]
