import socket
import sys

def scan_port(ip, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)  # Устанавливаем тайм-аут в 1 секунду
        result = sock.connect_ex((ip, port))  # connect_ex возвращает 0, если порт открыт
        sock.close()
        return result == 0
    except socket.error:
        return False

def scan_ports(ip, port_range):
    open_ports = []
    start_port, end_port = port_range

    print(f"Сканирование {ip} по портам  от {start_port} до {end_port}...")

    for port in range(start_port, end_port + 1):
        if scan_port(ip, port):
            print(f"Порт {port} открыт")
            open_ports.append(port)

    return open_ports

def parse_args():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <IP:port-range>")
        sys.exit(1)

    target = sys.argv[1]
    try:
        ip, ports = target.split(':')
        start_port, end_port = map(int, ports.split('-'))
        if start_port < 1 or end_port > 65535 or start_port > end_port:
            raise ValueError
    except ValueError:
        print("Неправильный формат. Используйте: <IP:port-range> (e.g. 127.0.0.1:1-1000)")
        sys.exit(1)

    return ip, (start_port, end_port)

if __name__ == "__main__":
    ip_address, port_range = parse_args()
    open_ports = scan_ports(ip_address, port_range)

    if open_ports:
        print(f"Открытые порты: {', '.join(map(str, open_ports))}")
    else:
        print("Открытых портов не обнаружено.")

