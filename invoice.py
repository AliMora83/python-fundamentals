from dataclasses import dataclass, field

@dataclass
class LineItem:
    description: str
    qty: int
    unit_price: float

    def __post_init__(self) -> None:
        if self.qty <= 0:
            raise ValueError("qty must be greater than 0")
        if self.unit_price < 0:
            raise ValueError("unit_price cannot be negative")

    def total(self) -> float:
        return self.qty * self.unit_price


@dataclass
class Invoice:
    customer: str
    lines: list[LineItem] = field(default_factory=list)

    def add_line(self, description: str, qty: int, unit_price: float) -> None:
        item = LineItem(description, qty, unit_price)
        self.lines.append(item)

    def subtotal(self) -> float:
        return round(sum(line.total() for line in self.lines), 2)

    def tax(self, rate: float = 0.15) -> float:
        if rate < 0:
            raise ValueError("rate cannot be negative")
        return round(self.subtotal() * rate, 2)

    def total(self, rate: float = 0.15) -> float:
        return round(self.subtotal() + self.tax(rate), 2)