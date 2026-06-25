FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/AlexandriaMobilityPlatform.Domain/AlexandriaMobilityPlatform.Domain.csproj", "src/AlexandriaMobilityPlatform.Domain/"]
COPY ["src/AlexandriaMobilityPlatform.Application/AlexandriaMobilityPlatform.Application.csproj", "src/AlexandriaMobilityPlatform.Application/"]
COPY ["src/AlexandriaMobilityPlatform.Infrastructure/AlexandriaMobilityPlatform.Infrastructure.csproj", "src/AlexandriaMobilityPlatform.Infrastructure/"]
COPY ["src/AlexandriaMobilityPlatform.API/AlexandriaMobilityPlatform.API.csproj", "src/AlexandriaMobilityPlatform.API/"]
RUN dotnet restore "src/AlexandriaMobilityPlatform.API/AlexandriaMobilityPlatform.API.csproj"
COPY . .
WORKDIR "/src/src/AlexandriaMobilityPlatform.API"
RUN dotnet build -c Release -o /app/build
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AlexandriaMobilityPlatform.API.dll"]
