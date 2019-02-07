FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY webapp.csproj ./
RUN dotnet restore
COPY . .
WORKDIR /src/
RUN dotnet build webapp.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish webapp.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "webapp.dll"]
