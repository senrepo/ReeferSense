# syntax=docker/dockerfile:1.4

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
ARG VSS_NUGET_EXTERNAL_FEED_ENDPOINTS
ENV VSS_NUGET_EXTERNAL_FEED_ENDPOINTS=$VSS_NUGET_EXTERNAL_FEED_ENDPOINTS

WORKDIR /src

# --- Put a NuGet.config WITH PROJECT-SCOPED FEED URL in the repo root ---
# (Ensure the file in your repo has the URL below.)
# <configuration>
#   <packageSources>
#     <add key="AzureArtifacts" value="https://pkgs.dev.azure.com/senazuredemo/ReeferSense/_packaging/ReeferSense/nuget/v3/index.json" />
#     <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
#   </packageSources>
# </configuration>
COPY NuGet.config /src/NuGet.config

# Copy only csproj first (layer caching)
COPY iot-data-processor/iot-data-processor.csproj iot-data-processor/

# --- DEBUG: show what the container sees (remove after it works) ---
RUN echo "NuGet.config content:" \
 && cat /src/NuGet.config \
 && echo "Auth JSON length: " $(echo -n "$VSS_NUGET_EXTERNAL_FEED_ENDPOINTS" | wc -c)

# Restore with config + built-in credential provider (uses env JSON)
RUN dotnet restore "iot-data-processor/iot-data-processor.csproj" --configfile /src/NuGet.config

# Copy the rest and build
COPY . .
WORKDIR /src/iot-data-processor
RUN dotnet build "iot-data-processor.csproj" -c $BUILD_CONFIGURATION -o /app/build --no-restore

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "iot-data-processor.csproj" -c $BUILD_CONFIGURATION -o /app/publish --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","iot-data-processor.dll"]
