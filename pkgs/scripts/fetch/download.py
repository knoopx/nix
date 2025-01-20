import pygame
import requests
import sys
import os
from urllib.parse import urlparse


class DownloadProgressViewer:
    def __init__(self):
        pygame.init()
        # Set up full screen display
        self.screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
        self.width = self.screen.get_width()
        self.height = self.screen.get_height()
        pygame.display.set_caption("Download Progress")

        # Colors
        self.BLACK = (0, 0, 0)
        self.WHITE = (255, 255, 255)
        self.BLUE = (0, 100, 255)

        # Font
        self.font = pygame.font.Font(None, 36)

    def format_size(self, bytes):
        """Convert bytes to human readable format"""
        for unit in ["B", "KB", "MB", "GB"]:
            if bytes < 1024:
                return f"{bytes:.1f} {unit}"
            bytes /= 1024
        return f"{bytes:.1f} TB"

    def download_file(self, url, save_path=None):
        if save_path is None:
            # Extract filename from URL
            filename = os.path.basename(urlparse(url).path)
            if not filename:
                filename = "downloaded_file"
            save_path = filename

        # Initialize download
        response = requests.get(url, stream=True)
        total_size = int(response.headers.get("content-length", 0))
        block_size = 1024
        downloaded = 0

        with open(save_path, "wb") as file:
            running = True
            while running:
                # Handle Pygame events
                for event in pygame.event.get():
                    if event.type == pygame.QUIT or (
                        event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE
                    ):
                        pygame.quit()
                        sys.exit()

                # Download chunk and update progress
                chunk = next(response.iter_content(block_size), None)
                if chunk:
                    file.write(chunk)
                    downloaded += len(chunk)
                else:
                    running = False

                # Calculate progress
                if total_size:
                    progress = (downloaded / total_size) * 100
                else:
                    progress = 0

                # Clear screen
                self.screen.fill(self.BLACK)

                # Draw progress bar
                bar_width = self.width * 0.8
                bar_height = 40
                bar_x = (self.width - bar_width) / 2
                bar_y = self.height / 2

                # Background bar
                pygame.draw.rect(
                    self.screen, self.WHITE, (bar_x, bar_y, bar_width, bar_height)
                )

                # Progress fill
                fill_width = (downloaded / total_size) * bar_width if total_size else 0
                pygame.draw.rect(
                    self.screen, self.BLUE, (bar_x, bar_y, fill_width, bar_height)
                )

                # Display percentage and size
                percentage_text = f"{progress:.1f}%"
                size_text = (
                    f"{self.format_size(downloaded)} / {self.format_size(total_size)}"
                )

                text_surface = self.font.render(percentage_text, True, self.WHITE)
                text_rect = text_surface.get_rect(
                    centerx=self.width / 2, bottom=bar_y - 20
                )
                self.screen.blit(text_surface, text_rect)

                size_surface = self.font.render(size_text, True, self.WHITE)
                size_rect = size_surface.get_rect(
                    centerx=self.width / 2, top=bar_y + bar_height + 20
                )
                self.screen.blit(size_surface, size_rect)

                # Update display
                pygame.display.flip()

        # Show completion message
        completion_text = "Download Complete! Press ESC to exit."
        text_surface = self.font.render(completion_text, True, self.WHITE)
        text_rect = text_surface.get_rect(
            center=(self.width / 2, self.height / 2 + 100)
        )
        self.screen.blit(text_surface, text_rect)
        pygame.display.flip()

        # Wait for ESC key
        waiting = True
        while waiting:
            for event in pygame.event.get():
                if event.type == pygame.QUIT or (
                    event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE
                ):
                    waiting = False

        pygame.quit()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <url> [save_path]")
        sys.exit(1)

    url = sys.argv[1]
    save_path = sys.argv[2] if len(sys.argv) > 2 else None

    viewer = DownloadProgressViewer()
    viewer.download_file(url, save_path)
