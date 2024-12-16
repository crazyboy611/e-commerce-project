<template>
    <div class="container my-5">
        <div class="cart-view">
            <div class="d-flex justify-content-between">
                <h1 class="text-bold">Shopping Cart</h1>
                <RouterLink to="/PurchaseOrder">
                    Purchase Order<i class="fa-solid fa-arrow-right ms-2"></i>
                </RouterLink>
            </div>
            <!-- Pass cartItems as prop to ListShoppingCart -->
            <ListShoppingCart :cartItems="cartItems" @update-cart="updateCart" />
        </div>
    </div>
</template>

<script>
import ListShoppingCart from "../components/ListShoppingCart.vue";

export default {
    name: 'ShoppingCartView',
    components: {
        ListShoppingCart,
    },
    props: {
        product: String, 
    },
    data() {
        return {
            cartItems: [],
            parsedProduct: null, 
        };
    },
    created() {

        const storedCart = sessionStorage.getItem('cartProducts');


        try {
            this.parsedProduct = JSON.parse(decodeURIComponent(this.product));

            this.cartItems = storedCart ? JSON.parse(storedCart) : [];

            const cartProduct = {
                id: this.parsedProduct.id,
                name: this.parsedProduct.name,
                image: this.parsedProduct.image,
                quantity: 1,
                quantityInStock: this.parsedProduct.quantity,
                price: this.parsedProduct.price,
                thumbnail: this.parsedProduct.thumbnail,
                color: this.parsedProduct.color,
                memory: this.parsedProduct.memory
            };

            const existingProduct = this.cartItems.find(item => item.id === cartProduct.id);

            if (existingProduct) {
                if (existingProduct.quantity + 1 > existingProduct.quantityInStock) {
                    alert(`Not enough products`);
                    existingProduct.quantity = existingProduct.quantityInStock;
                } else {
                    existingProduct.quantity += 1;
                }
            } else {
                this.cartItems.push(cartProduct);
            }
            sessionStorage.setItem('cartProducts', JSON.stringify(this.cartItems));
        } catch (error) {
            console.error('Error parsing product:', error);
        }
    },
    methods: {
        updateCart(updatedItems) {
            // Update cartItems in the parent component with the emitted data
            this.cartItems = updatedItems;
            // Emit event if necessary to notify further parent components (if any)
            this.$emit('update-cart', updatedItems);
        },
    }
}
</script>
<style scoped>
.cart-view {
    margin: 8% 0;
}

a {
    text-decoration: none;
}

a:hover {
    color: #333;
}
</style>