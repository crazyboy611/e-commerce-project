<template>
    <div class="container-fuild text-white">
        <footer class="container p-3">
            <div class="d-flex flex-wrap justify-content-evenly">
                <div class="logo mt-5">
                    <img class="mb-3" src="../ImageIcon/LogoFooter.png" alt="">
                    <p class="mt-3 fw-bold">We always put quality and reputation fisrt.
                    </p>
                </div>
                <div class="d-flex justify-content-evenly">
                    <div class="mt-5">
                        <b class="mb-3 fs-4">Service</b>
                        <p class="mt-3 fw-bold"><a href="/">Gift cards</a></p>
                        <p class="fw-bold"><a href="/checkout">Delivery and Receive</a></p>
                        <a class="nav-link dropdown-toggle fw-bold" href="#" role="button" data-bs-toggle="dropdown"
                            aria-expanded="false">
                            Payment
                        </a>

                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/checkout">Pay cash</a></li>
                            <li><a class="dropdown-item" href="/checkout">
                                    Bank transfer</a></li>
                        </ul>
                        <div class="mt-4">
                            <img src="https://bizweb.dktcdn.net/100/449/923/themes/875305/assets/icon_payment_1.png?1724744722167"
                                alt="">
                            <img src="https://bizweb.dktcdn.net/100/449/923/themes/875305/assets/icon_payment_2.png?1724744722167"
                                alt="">
                            <img src="https://bizweb.dktcdn.net/100/449/923/themes/875305/assets/icon_payment_3.png?1724744722167"
                                alt="">
                        </div>
                    </div>
                    <div class="mt-5">
                        <b class="mb-3 fs-4 fw-bold">Assistance to buyer</b>
                        <p class="mt-3 fw-bold find-pd"><a href="/ProductList#search-input">Find a product</a></p>
                        <p class="fw-bold"><a href="#home-view-discount">Discount Product</a></p>
                    </div>
                </div>
            </div>
            <div class="contact text-center mt-5 mb-3">
                <a class="fw-bold" href="/"><i class="fa-solid fa-envelope fs-3"></i></a>
                <a class="fw-bold" href="/"><i class="fa-brands fa-x-twitter fs-3"></i></a>
                <a class="fw-bold" href="/"><i class="fa-brands fa-facebook fs-3"></i></a>
            </div>
            <div class="text-center pb-3 fw-bold">Create by <span class="text-warning fs-4">@Team7.cc</span></div>
        </footer>
    </div>
</template>

<script>

export default {
    name: 'FooterPage',
    methods:{
        getfocus() {
            document.getElementById("search-input").focus();
        }
    }
}
</script>
<style scoped>
* {
    padding: 0;
    margin: 0;
    box-sizing: border-box;
}

.container-fuild {
    background-color: #000000;
}

.dropdown-menu {
    outline: none;
    background-color: #000000;
}

.dropdown-menu a {
    color: #ffffff;
}

.mt-4 img {
    margin: 5px;
}

.contact i {
    color: #ffffff;
    font-size: 20px;
    margin: 10px;
    cursor: pointer;
}

a {
    color: #ffffff;
    text-decoration: none;
}

a:hover {
    color: #646464;
}

.contact i:hover {
    color: #646464;
}
.find-pd:hover{
    cursor: pointer;
    color: #646464;
}
@media only screen and (max-width: 600px) {}
</style>
