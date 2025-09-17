
from django.db import models

# Create your models here.

class Product(models.Model):
	name = models.CharField(max_length=255)
	price = models.DecimalField(max_digits=10, decimal_places=2)
	picture = models.ImageField(upload_to='product_pictures/', blank=True, null=True)
	rating = models.FloatField(default=0)
	created_at = models.DateTimeField(auto_now_add=True)

	def __str__(self):
		return self.name + str(self.price)
