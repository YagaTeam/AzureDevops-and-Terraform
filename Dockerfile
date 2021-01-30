FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build-env
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "weatherapi.dll"]