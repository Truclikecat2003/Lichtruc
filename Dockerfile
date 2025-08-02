# ======== BUILD IMAGE ========
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution và csproj trước để tận dụng cache
COPY LichTruc.sln .
COPY LichTruc/*.csproj ./LichTruc/

# Restore dependencies
RUN dotnet restore LichTruc.sln

# Copy toàn bộ mã nguồn sau restore
COPY . .

# Build & publish
WORKDIR /src/LichTruc
RUN dotnet publish -c Release -o /app/publish

# ======== RUNTIME IMAGE ========
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "LichTruc.dll"]
