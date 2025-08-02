# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy toàn bộ thư mục hiện tại (vì đã chứa .sln và project con)
COPY . .

# Khôi phục từ file .sln
RUN dotnet restore LichTruc.sln

# Build & publish
WORKDIR /src/LichTruc
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Run
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "LichTruc.dll"]
